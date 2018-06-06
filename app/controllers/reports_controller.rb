class ReportsController < ApplicationController
  before_action :set_report, only: [:edit, :update, :destroy]

  access user: [:index], site_admin: :all
  
  def index
    @reports = Report.all
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to reports_path, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new, alert: "Report could not be created" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update     
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to reports_path, notice: 'The record was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end     
  end

  def destroy

    @report.destroy
      
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Record was successfully removed.' }
    end
  end
  
  private 

    def report_params
      params.require(:report).permit(:name, :content, :approved)
    end

    def set_report
      @report = Report.find(params[:id])
    end
end
