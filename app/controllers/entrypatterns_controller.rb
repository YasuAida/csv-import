class EntrypatternsController < ApplicationController
  def index
    @entrypatterns = Entrypattern.all
  end
end
