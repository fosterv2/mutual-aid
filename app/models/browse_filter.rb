# BrowseFilter code currently makes a lot of assumptions about the model coming in
# I'm going to have to some lifting to make it accept other models
# but at least all these changes will be isolated to this class
class BrowseFilter
  FILTERS = [ContributionTypeFilter, CategoryFilter, ServiceAreaFilter, ContactMethodFilter]
  # FILTERS = {
  #   'ServiceArea' => ->(ids, scope) { scope.where(service_area: ids) },
  #   'ContactMethod' => ->(ids, scope) { scope.joins(:person).where(people: {preferred_contact_method: ids})},
  #   'Category' => lambda do |ids, scope|
  #     scope.tagged_with(
  #       Category.roots.where(id: ids).pluck('name'),
  #       any: true
  #     )
  #   end,
  #   'UrgencyLevel' => lambda do |ids, scope|
  #     ids.length == UrgencyLevel::TYPES.length ? scope : scope.where(urgency_level_id: ids)
  #   end
  # }.freeze

  ALLOWED_MODEL_NAMES = ['Ask', 'Offer'].freeze
  # ALLOWED_PARAMS = (['ContributionType'] + FILTERS.keys).each_with_object({}) do |key, hash|
  #   hash[key] = {}
  # end.freeze

  attr_reader :parameters, :context

  def self.filter_options_json
    FILTERS.map(&:options).to_json
  end

  def initialize(parameters, context = nil)
    @parameters = parameters
    @context = context
  end

  def contributions
    model_names = parameters['ContributionType']&.keys || ALLOWED_MODEL_NAMES
    models = model_names.intersection(ALLOWED_MODEL_NAMES).map(&:constantize)
    @contributions ||= models.map { |model| filters(model) }.flatten
  end

  def options
    return {} unless context

    {
      profile_path: ->(id) { context.person_path(id) },
      respond_path: ->(id) { context.respond_contribution_path(id)},
      match_path: ->(id) { Listing.find(id).type == "Ask" ? context.new_match_path(receiver_id: id) : context.new_match_path(provider_id: id)}
    }
  end

  private

  def filters(model)
    # parameters.keys.reduce(model.unmatched) do |scope, key|
    #   filter = FILTERS.fetch(key, ->(_condition, s) {s})
    #   filter.call(parameters[key], scope)
    # end

    FILTERS.reduce(model.unmatched) do |relation, filter|
      filter.filter(relation, parameters)
    end
  end
end
