class Api::V1::SleepTimeRecordsController < ApplicationController
  
  include Pagy::Backend

  before_action :set_user, only: [:index, :create]
  
  def index
    sleep_time_records = @user.sleep_time_records.order(sleep_time: :desc)
    @pagy, records = pagy(sleep_time_records, items: params[:page_size] || Pagy::DEFAULT[:items])
    render json: { records: records, pagy: @pagy }
  end

  def create
    sleep_record = @user.sleep_time_records.new(sleep_record_params)
    if sleep_record.save
      render json: sleep_record, status: :created
    else
      render json: { errors: sleep_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def clock_in
    @user = User.find(params[:user_id])
    sleep_record = @user.sleep_time_records.new(sleep_time: Time.current)
    
    if sleep_record.save
      render json: sleep_record, status: :created
    else
      render json: { errors: sleep_record.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def sleep_time_record_params
    params.require(:sleep_time_record).permit(:sleep_time, :wake_time)
  end
end