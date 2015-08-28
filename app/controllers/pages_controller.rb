class PagesController < ApplicationController

  def landing_page
    redirect_to front_path if user_has_finished_necessary_settings?
  end

  def about
  end

  def useful_links
  end

  def advice
  end
end
