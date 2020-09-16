class Movie < ActiveRecord::Base
   # attr_accessible :title, :rating, :description, :release_date
        #Get a ratings
        def self.all_ratings
            self.all.pluck(:rating).uniq.sort_by
        end
end
