# frozen_string_literal: true

# Controlador de Ambientes
class AmbientesController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize Ambiente
    @ambientes = if params[:q].present?
                   Ambiente.where(
                     'nombre ilike :q or descripcion ilike :q',
                     q: "%#{params[:q]}%"
                   ).page params[:page]
                 else
                   Ambiente.all.page params[:page]
                 end
  end

  def show
    @ambiente = Ambiente.find(params[:id])
  end

  def edit
    @ambiente = Ambiente.find(params[:id])
  end

  def new
    @ambiente = Ambiente.new
  end

  def create
    @ambiente = Ambiente.new(ambiente_params)
    if @ambiente.save
      redirect_to ambiente_path(@ambiente), notice: 'Se ha creado el ambiente'
    else
      render 'new'
    end
  end

  def update
    @ambiente = Ambiente.find(params[:id])
    if @ambiente.update_attributes(ambiente_params)
      redirect_to ambiente_path(@ambiente), notice: 'Se ha Midificado el ambiente'
    else
      render 'edit'
    end
  end

  def ver_ambiente
    render template: 'ambientes/show'
  end

  private

  def ambiente_params
    params.require(:ambiente).permit(:nombre, :descripcion)
  end
end
