# encoding: UTF-8

class ReportsController < ApplicationController
  # GET /reports
  # GET /reports?mine=true
  # GET /reports.json
  def index

    #   state   = params[:state]   if params[:state].present?


    north_east = params[:northEast].split(',') if params[:northEast].present?
    south_west = params[:southWest].split(',') if params[:southWest].present?

    if north_east.present? && south_west.present?

      north_east.collect! { |x| x.to_f }
      south_west.collect! { |x| x.to_f }
      #Google uses LatLng, Mongo uses LngLat
      north_east.reverse!
      south_west.reverse!
      @reports = Report.where(:coordinates => {"$within" => {"$box" => [north_east, south_west]}})
    else
      @reports = Report.all.desc(:created_at)
    end


    #if params[:mine].try(:to_bool)
    #  @reports = Report.where(
    #      :user => User.find_by(:uuid => request.headers[CLIENT_IDENTIFIER_KEY])
    #  ).desc(:created_at)
    #else
    #  @reports = Report.all.desc(:created_at)
    #end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
      format.xml { render xml: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new
    @report.photos.build

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
    end
  end

  # POST /reports
  # POST /reports.json
  def create
    #requested_uuid = request.headers[CLIENT_IDENTIFIER_KEY]
    @report = Report.new(params[:report])
    @report.user = User.find_or_create_by(params[:user])

    if request.env["HTTP_X_FORWARDED_FOR"].present?
      @report.client_ip = request.env["HTTP_X_FORWARDED_FOR"]
    else
      @report.client_ip = request.remote_ip
    end

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: t(:created_report) }
        format.json { render json: @report, status: :created, location: @report }
      else
        @report.photos.build if @report.photos.empty?
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /reports/1/edit?token=ABCDE
  def edit
    @report = Report.find_by(:id => params[:id], :token => params[:token])
  end

  # PUT /reports/1/extend
  # PUT /reports/1/extend.json
  def extend
    @report = Report.find_by(:id => params[:id], :token => params[:report][:token])
    @report.update_confirmation
    @report.save
    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: t(:update_report) }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      else
        # TODO
      end
    end
  end


  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find_by(:id => params[:id], :token => params[:report][:token])
    @report.mark_as_solved
    @report.save
    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: t(:update_report) }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      else
        # TODO
      end
    end
  end

end
