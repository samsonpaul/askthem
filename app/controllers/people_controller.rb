class PeopleController < ApplicationController
  inherit_resources
  respond_to :html
  actions :index, :show

  before_filter :set_jurisdiction

private

  def collection
    end_of_association_chain.where(state: @jurisdiction.id, active: true)
  end
end