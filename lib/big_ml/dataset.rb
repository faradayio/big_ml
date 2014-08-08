require 'big_ml/base'

module BigML
  class Dataset < Base
    DATASET_PROPERTIES = [
      :category, :code, :columns, :created, :credits,
      :description, :fields, :locale, :name, :number_of_models,
      :number_of_predictions, :private, :resource, :rows, :size,
      :source, :source_status, :status, :tags, :updated
    ]

    attr_reader *DATASET_PROPERTIES

    def to_model
      Model.create(resource)
    end

    class << self
      def create(source_or_dataset, options = {})
        body = {}
        body.merge! options
        if source_or_dataset.start_with?('source')
          body[:source] = source_or_dataset
        elsif source_or_dataset.start_with?('dataset')
          body[:origin_dataset] = source_or_dataset
        else
          raise ArgumentError, "Expected source or dataset, got #{source_or_dataset.inspect}"
        end
        response = client.post("/#{resource_name}", {}, body)
        self.new(response) if response.success?
      end
    end
  end
end
