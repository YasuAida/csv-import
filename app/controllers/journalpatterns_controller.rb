class JournalpatternsController < ApplicationController
  def index
    @journalpatterns = Journalpattern.all
  end
end
