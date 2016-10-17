class PladminsController < ApplicationController
  def index
    @pladmins = Pladmin.all
  end
end
