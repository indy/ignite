


class Tad < Ignite::BaseIgnitor
  
  def description
    "Builds the folder structure for a content provider"
  end

  # the parent directory that this ignite will be run from, 
  # defaults to wherever ignite was invoked from
  def parent_directory
    File.join(%w{C: work})
  end
end






