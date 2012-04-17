class JobsController < ApplicationController
  
  def index
    @jobs = Job.all
    gon.jobs = @jobs
  end
end
