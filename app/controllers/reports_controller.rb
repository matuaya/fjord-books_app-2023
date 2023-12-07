# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save

      mentioning_ids = get_ids_from_urls(@report.content)
      mentioning_ids.each do |id|
        mentioning_report = Report.find(id)
        create_record_relationship(mentioning_report.id, @report.id)
      end

      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    original_mentioning_report_ids = @report.mentioning_reports.pluck(:id)

    if @report.update(report_params)

      updated_mentioning_report_ids = get_ids_from_urls(@report.content)

      updated_mentioning_report_ids.each do |id|
        mentioning_report = Report.find(id)
        create_record_relationship(mentioning_report.id, @report.id) unless original_mentioning_report_ids.include?(id)
      end

      deleted_mentions = original_mentioning_report_ids - updated_mentioning_report_ids

      deleted_mentions.each do |mention|
        relationship = Relationship.find_by(mentioning_id: mention, mentioned_id: @report.id)
        relationship&.destroy
      end

      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def get_ids_from_urls(content)
    @report.content.scan(%r{localhost:3000/reports/(\d+)}).uniq.flatten.map(&:to_i)
  end

  def create_record_relationship(mentioning_report, mentioned_report)
    Relationship.create(mentioning_id: mentioning_report, mentioned_id: mentioned_report)
  end
end
