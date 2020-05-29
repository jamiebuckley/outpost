task :process_deletions => :environment do
    Service.discarded.each do |s|
        # TODO: Check if marked for deletion greater than 30 days ago
        # if s.marked_for_deletion ?????
        #     s.destroy
        #     s.save
        # end
    end
end