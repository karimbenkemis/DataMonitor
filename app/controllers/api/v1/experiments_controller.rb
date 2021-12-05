class Api::V1::ExperimentsController < ApplicationController
    include JSONAPI::Deserialization

    def index
        experiments = Experiment.where(researcher_id: @researcher.id)
        experiments = experiments.map do |experiment|
            experiment.slice(*display_params)
        end
        
        render json: { results: experiments }.to_json, status: :ok
    end

    def create
        experiment_data = params.require(:experiment).permit(*post_params)
        experiment_data[:researcher_id] = @researcher.id
        experiment = Experiment.new(experiment_data)

        experiment[:signal] = experiment.data.map do |input_signal|
            input_signal > experiment.threshold ? 1 : 0
        end

        Rails.logger.info "experiment: #{experiment.to_json}"

        if experiment.save
            render json: experiment.slice(*display_params), status: :created
        else
            render json: experiment.errors, status: :unprocessable_entity
        end
    end

    private

    def post_params
        [:threshold, data: []]
    end

    def display_params
        [:id, :data, :threshold, :signal]
    end
end