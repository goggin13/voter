class FaceOffsController < ApplicationController
  before_action :set_face_off, only: [:show, :edit, :update, :destroy]

  # GET /face_offs
  # GET /face_offs.json
  def index
    @face_offs = FaceOff.all
  end

  # GET /face_offs/1
  # GET /face_offs/1.json
  def show
  end

  # GET /face_offs/new
  def new
    @face_off = FaceOff.new
  end

  # GET /face_offs/1/edit
  def edit
  end

  # POST /face_offs
  # POST /face_offs.json
  def create
    @face_off = FaceOff.new(face_off_params)

    respond_to do |format|
      if @face_off.save
        format.json { render :show, status: :created, location: @face_off }
      else
        format.json { render json: @face_off.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /face_offs/1
  # PATCH/PUT /face_offs/1.json
  def update
    respond_to do |format|
      if @face_off.update(face_off_params)
        format.html { redirect_to @face_off, notice: 'Face off was successfully updated.' }
        format.json { render :show, status: :ok, location: @face_off }
      else
        format.html { render :edit }
        format.json { render json: @face_off.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /face_offs/1
  # DELETE /face_offs/1.json
  def destroy
    @face_off.destroy
    respond_to do |format|
      format.html { redirect_to face_offs_url, notice: 'Face off was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_face_off
      @face_off = FaceOff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def face_off_params
      params
        .require(:face_off)
        .permit(:loser_id, :winner_id)
        .merge(:user_id => current_user.id)
    end
end
