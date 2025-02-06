class CertificatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :set_certificate, only: [:show]

  # GET /certificates/1 or /certificates/1.json
   
  def show
    return if !current_user.student.present?
    @course = Course.find(params[:course_id])
    @certificate = Certificate.find_by(student_id: current_user.student.id, course_id: @course.id)
    @student = Student.find_by(id: params[:student_id]) # Adjust if needed
    respond_to do |format|
      format.html
      format.pdf do
        WickedPdf.config = { exe_path: '/home/ror/.rvm/gems/ruby-3.2.1/bin/wkhtmltopdf' }

        pdf = render_to_string pdf: "certificate",
                               template: "certificates/show",
                               formats: [:html]

        send_data pdf, filename: "certificate.pdf", type: "application/pdf", disposition: "attachment"
      end
    end
  end

  # GET /certificates/new
  def new
    @course = Course.find(params[:course_id])
    @certificate = Certificate.new
  end

  # GET /certificates/1/edit
  def edit
  end

  # POST /certificates or /certificates.json
  def create
    @certificate = Certificate.new(certificate_params)

    respond_to do |format|
      if @certificate.save
        format.html { redirect_to @certificate, notice: "Certificate was successfully created." }
        format.json { render :show, status: :created, location: @certificate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /certificates/1 or /certificates/1.json
  def update
    respond_to do |format|
      if @certificate.update(certificate_params)
        format.html { redirect_to @certificate, notice: "Certificate was successfully updated." }
        format.json { render :show, status: :ok, location: @certificate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /certificates/1 or /certificates/1.json
  def destroy
    @certificate.destroy!

    respond_to do |format|
      format.html { redirect_to certificates_path, status: :see_other, notice: "Certificate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
   def set_course
     @course = Course.find(params[:course_id])
   end

     def set_certificate
      @certificate = Certificate.find(params[:id])
     end

    # Only allow a list of trusted parameters through.
    def certificate_params
      params.fetch(:certificate, {})
    end
end
