namespace :name_organisations do

  desc "looks for common strings in organisations with multiple services"

  task :by_common_service_strings => [ :environment ] do
    
    Organisation.joins(:services).group('organisations.id').having('count(services.id) > 1').each do |org| # orgs with more than one service
      service_names = org.services.map{ |service| service.name }
      common_sequences = phrase_in_common(service_names[0], service_names[1])
      puts "Org id: #{org.id}"
      puts "Services:"
      puts service_names
      puts ""
      # if org.id == 1940
      #   byebug
      # end
      if service_names.size > 2
        upper_limit = service_names.size - 1 
        for i in 2..upper_limit do
          common_sequences = phrase_in_common(common_sequences, service_names[i]) unless common_sequences == nil
        end
      end
      # longest_common_string = longest_common_substr(service_names).strip
      # org.name = longest_common_string
      # puts "Service names:"
      # puts service_names
      # puts "Org name:"
      # puts org.name
      # puts "---"
      puts "New org name: #{common_sequences}"
      puts "---"
    end

  end
end

# def longest_common_substr(strings)
#   shortest = strings.min_by &:length
#   maxlen = shortest.length
#   maxlen.downto(0) do |len|
#     0.upto(maxlen - len) do |start|
#       substr = shortest[start,len]
#       return substr if strings.all?{|str| str.include? substr }
#     end
#   end
# end



def split_into_words(string)
  string.gsub(/[()]/, "").split(/[\s\.,;\'\"]/)
end

def longest_subsequence(xstr, ystr)
  return '' if xstr.empty? || ystr.empty?

  x, *xs = xstr
  y, *ys = ystr

  if x == y
    x + " " + longest_subsequence(xs, ys)
  else
    [longest_subsequence(xstr, ys), longest_subsequence(xs, ystr)].max_by {|x| x.size}
  end
end

def phrase_in_common(string1, string2)
  xstr = split_into_words(string1)
  ystr = split_into_words(string2)
  longest_subsequence(xstr, ystr).strip.presence
end
