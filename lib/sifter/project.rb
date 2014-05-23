# Wrapper for a Sifter project. Fetch projects using Sifter::Account.
class Sifter::Project < Hashie::Dash

  property :name
  property :archived
  property :primary_company_name
  property :url
  property :api_url
  property :issues_url
  property :milestones_url
  property :people_url
  property :api_milestones_url
  property :api_people_url
  property :api_issues_url
  property :api_categories_url

  # Return all issues from a project. Accepts status and priority flags.
  # Use Sifter::Account.statuses & Sifter::Account.priorities to view 
  # valid options.
  def issues(status=nil, prioirty=nil)

    issues = []

    # Build filter string
    filters = "&s=#{status}" if status
    filters.to_s << "&p=#{priority}" if prioirty
    
    # Inital request url
    issues_url = api_issues_url + "?page=1&per_page=100" + filters
    
    while issues_url do  # while next_page_url is not nil add issues to the list  
      page = Sifter.get(issues_url + filters.to_s)
      
      issues += page.fetch("issues", []).map { |p| Sifter::Issue.new(p) }
      issues_url = page.fetch("next_page_url")
    end

    issues
  end

  # Fetch all the milestones for this project. Returns an array of
  # Sifter::Milestone objects.
  def milestones
    Sifter.
      get(api_milestones_url).
      fetch("milestones", []).
      map { |m| Sifter::Milestone.new(m) }
  end

  # Fetch all the people linked to this project. Returns an array of
  # Sifter::Person objects.
  def people
    Sifter.
      get(api_people_url).
      fetch("people", []).
      map { |p| Sifter::Person.new(p) }
  end

end
