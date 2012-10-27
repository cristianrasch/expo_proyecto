class GenerateSlugsForExistingProjects < ActiveRecord::Migration
  def self.up
    Project.where(slug: nil).find_each(&:save)
  end

  def self.down
  end
end
