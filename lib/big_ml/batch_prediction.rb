require 'big_ml/base'

require 'tmpdir'
require 'uri'
require 'net/http'

module BigML
  class BatchPrediction < Base
    BATCH_PREDICTION_PROPERTIES = [
      :category, :code, :created, :credits, :dataset, :dataset_status,
      :description, :fields, :dataset, :model, :model_status, :name,
      :objective_fields, :prediction, :prediction_path, :private, :resource,
      :source, :source_status, :status, :tags, :updated
    ]

    attr_reader *BATCH_PREDICTION_PROPERTIES

    class << self
      def create(model_or_ensemble, dataset, options = {})
        body = {}
        body.merge! options
        body[:dataset] = dataset
        if model_or_ensemble.start_with? 'model'
          body[:model] = model_or_ensemble
        elsif model_or_ensemble.start_with? 'ensemble'
          body[:ensemble] = model_or_ensemble
        else
          raise ArgumentError, "Expected model or ensemble, got #{model_or_ensemble}"
        end
        response = client.post("/#{resource_name}", {}, body)
        self.new(response) if response.success?
      end

      def download(id)
        response = client.get("/#{resource_name}/#{id}/download")
        response.body if response.success?
      end

      # standard Net::HTTP usage pulled from http://ruby-doc.org/stdlib-1.9.3/libdoc/net/http/rdoc/Net.html
      # FIXME this is production only because we're hitting andromeda not dev/andromeda
      # FIXME quick and dirty tmp path creation
      def download_to_tmp_path(id)
        tmp_path = File.join Dir.tmpdir, "#{rand.to_s}.csv"
        uri = URI("https://bigml.io/andromeda/#{resource_name}/#{id}/download")
        uri.query = URI.encode_www_form client.credentials
        Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
          request = Net::HTTP::Get.new uri.request_uri
          http.request request do |response|
            File.open tmp_path, 'w' do |io|
              response.read_body do |chunk|
                io.write chunk
              end
            end
          end
        end
        tmp_path
      end
    end

    def download
      self.class.download(id)
    end

    def download_to_tmp_path
      self.class.download_to_tmp_path(id)
    end

  end
end
