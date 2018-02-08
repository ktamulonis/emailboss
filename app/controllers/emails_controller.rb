class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :edit, :update, :destroy]

  def upload
  uploaded_io = params[:email][:original]
  File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
    end
  end

  # GET /emails
  # GET /emails.json
  def index
    @emails = Email.all
  end

  # GET /emails/1
  # GET /emails/1.json
  def show
  end

  # GET /emails/new
  def new
    @email = Email.new
  end

  # GET /emails/1/edit
  def edit
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = Email.new(email_params)
    parse_email
    respond_to do |format|
      if @email.save
        format.html { redirect_to @email, notice: 'Email was successfully created.' }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emails/1
  # PATCH/PUT /emails/1.json
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to @email, notice: 'Email was successfully updated.' }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email.destroy
    respond_to do |format|
      format.html { redirect_to emails_url, notice: 'Email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_params
      params.require(:email).permit(:to_name, :from_name, :to_email, :from_email, :subject)
    end
    
    def parse_email
      @original = params[:email][:original].read
      @original.lines.each_with_index do |line, index|
      if line.include? "Subject:"
        @email.update_attribute( :subject, line.slice!(9, line.length) )
      end
      if line.include? "From: "
        @from = line.slice!(6, line.length)
        @from_name = @from.slice!(0..(@from.index('<')-1))
        @from_email = @from.slice!((@from.index('<')+1)..(@from.index('>')-1))
        @email.update_attribute( :from_name, @from_name)
        @email.update_attribute( :from_email, @from_email)  
      end

      if line.include? "To: " and line.exclude? "-To:"
        @to = line.slice!(4, line.length)
        @to_name = @to.slice!(0..(@to.index('<')-1))
        @to_email = @to.slice!((@to.index('<')+1)..(@to.index('>')-1))
        @email.update_attribute( :to_name, @to_name)
        @email.update_attribute( :to_email, @to_email) 
      end
      # if line.include? "Content-Type: text/plain; charset=UTF-8" 
      #   @content_start = index+2
      # end
      # if line.start_with? "On "
      #   @content_stop = index
      # end
      # if @content_start && @content_stop
      #   @content = @original.lines.slice!(@content_start, @content_stop)
      #   @email.update_attribute(:content, @content)
      # end
    end
  end


end
