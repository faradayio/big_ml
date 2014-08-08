require 'big_ml/base'

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
    end

    def download
      self.class.download(id)
    end

  end
end
