class ReportsController < ApplicationController
  before_action :set_report, only: [:edit, :update, :destroy, :approve]

  access user: [:index], site_admin: {except: [:approve]}, doctors: [:index, :approve]
  
  def index
    @reports = Report.all
  end

  def new
    @report = Report.new
  end

  def create
    # Make an object in your bucket for your upload
    obj = AWS::S3.new.buckets[ENV['S3_BUCKET_NAME']].objects[params[:report][:file].original_filename]
    
    # Upload the file
    obj.write(
      file: params[:report][:file],
      acl: :public_read
    )
    
    @report = Report.new(report_params)
    
    @report.content = obj.public_url

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
    if @report.approved == true
      respond_to do |format|
        format.html { redirect_to reports_url, notice: 'Report has already been approved.' }
      end
    end

    io = open(@report.content.to_s)
    doc = HexaPDF::Document.open(io)
    page = doc.pages[0]
    canvas = page.canvas(type: :overlay)
    canvas.translate(0, 20) do
      img = open(current_user.signature.to_s)  
      puts "img is a #{img.class}"
      if img.class == StringIO
        file = Tempfile.new(['temp','.png'])
        file.binmode
        file.write img.read
        canvas.image(File.join(file), at: [30, 250], width: 70, height: 50)
      else
        canvas.image(File.join(img), at: [30, 250], width: 70, height: 50)
      end
    end

    doc.write("graphics.pdf", optimize: true)
    obj = AWS::S3.new.buckets[ENV['S3_BUCKET_NAME']].objects["reports/#{@report.id}/#{@report.name}"]

    obj.write(
      file: "graphics.pdf",
      acl: :public_read
    )
    File.delete("graphics.pdf") if File.exist?("graphics.pdf")
    @report.update!(content: obj.public_url, approved: true)
    @report.save
  end 
  
  private 

    def report_params
      params.require(:report).permit(:name, :content, :approved)
    end

    def set_report
      @report = Report.find(params[:id])
    end
end