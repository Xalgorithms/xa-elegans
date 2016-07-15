module OrganizationHelper
  def organize(collection, length)
    if collection
      [collection[0...length]] + organize(collection[length..-1], length)
    else
      []
    end
  end
end
