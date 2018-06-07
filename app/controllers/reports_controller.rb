class ReportsController < ApplicationController
  before_action :set_report, only: [:edit, :update, :destroy, :approve]

  access user: [:index], site_admin: :all, doctors: [:index, :approve]
  
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

  def approve
    io = open(@report.content.to_s)
    # reader = PDF::Reader.new(io)
    # puts reader.inspect

    # image = open(current_user.signature.to_s)
    # pdf = PDF::Stamper.new(image) 
    # pdf.text :first_name, "Jason"
    # pdf.text :last_name, "Yates" 
    # send_data(pdf.to_s, :filename => "output.pdf", :type => "application/pdf",:disposition => "inline")

    doc = HexaPDF::Document.open(io)
    page = doc.pages[0]
    canvas = page.canvas(type: :overlay)

    canvas.translate(0, 20) do
      # canvas.fill_color(0.3, 0.7, 0.7)
      # canvas.rectangle(50, 0, 80, 80, radius: 80)
      # canvas.fill

      # solid = canvas.graphic_object(:solid_arc, cx: 190, cy: 40, inner_a: 20, inner_b: 15,
      #                               outer_a: 40, outer_b: 30, start_angle: 10, end_angle: 130)
      img = open(current_user.signature.to_s)
      # canvas.line_width(0.5)  
      canvas.image(File.join(img), at: [400, 0], height: 80)
    end
    doc.write('graphics.pdf', optimize: true)
  end 
  
  private 

    def report_params
      params.require(:report).permit(:name, :content, :approved)
    end

    def set_report
      @report = Report.find(params[:id])
    end
end
