require 'big_ml/base'

module BigML
  class Source < Base
    SOURCE_PROPERTIES = [
      :code, :content_type, :created, :credits, :fields, :file_name, :md5, 
      :name, :number_of_datasets, :number_of_models, :number_of_predictions, 
      :private, :resource, :size, :source_parser, :status, :type, :updated
    ]

    attr_reader *SOURCE_PROPERTIES

    def to_dataset
      Dataset.create(resource)
    end

    class << self
      def create(file_or_url)
        query = {}
        body = {}
        if file_or_url.start_with?('http')
          body[:remote] = file_or_url
        else
          query.merge! multipart: true, file: File.new(file_or_url)
        end
        response = client.post("/#{resource_name}", query, body)
        self.new(response) if response.success?
      end
    end
  end
end
