require 'big_ml/base'

module BigML
  class Model < Base
    MODEL_PROPERTIES = [
      :category, :code, :columns, :created, :credits, 
      :dataset, :dataset_status, :description, :holdout, 
      :input_fields, :locale, :max_columns, :max_rows, :model, 
      :name, :number_of_predictions, :objective_fields, :private, 
      :range, :resource, :rows, :size, :source, :source_status, 
      :status, :tags, :updated
    ]

    attr_reader *MODEL_PROPERTIES

    def to_prediction(options)
      Prediction.create(resource, options)
    end

    class << self
      def create(dataset, options = {})
        body = {}
        body.merge! options
        body[:dataset] = dataset
        response = client.post("/#{resource_name}", {}, body)
        self.new(response) if response.success?
      end
    end
  end
end
