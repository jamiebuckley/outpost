require 'csv'

# Create bucks and fg users
user_logins_yaml = Rails.root.join('lib', 'seeds', 'user_logins.yml')
user_logins = YAML::load_file(user_logins_yaml)
User.create!(user_logins)

# Seed users from old DB
users_file = File.open('lib/seeds/users.csv', "r:ISO-8859-1")
users_csv = CSV.parse(users_file, headers: true)

csv_file = File.open('lib/seeds/bucksfis geo.csv', "r:ISO-8859-1")
bucks_csv = CSV.parse(csv_file, headers: true)

bucks_csv.each.with_index do |row, line|
  puts "Processing service #{row.line} of #{bucks_csv.size}"
  byebug
  service = ChildcareService.new if row['service_type'] == 'Childcare'
  service ||= Service.new

  service.name = row['title']
  service.description = ActionView::Base.full_sanitizer.sanitize(row['description'])
  service.email = row['contact_email']
  service.url = row['website']

  # if row['title'] == '12th Aylesbury Brownies'
  #   byebug
  # end

  old_users = users_csv.select{ |user_row| user_row['externalId'] == row['record_editor'] } # users from open objects csv
  new_users = User.where(email: row['contact_email']) # new database users already created by this seed

  if new_users.size == 1 # If an organisation already exists with user, assign service to organisation
    organisation = new_users.first.organisation
  elsif new_users.size == 0 # Otherwise create a new organisation and user
    organisation = Organisation.create
    if old_users.size == 1 # See if there is an associated user in open objects, create it in new db and associate it via org
      old_user = old_users.first
      password = SecureRandom.hex(8)
      user = User.new
      user.email = old_user['email']
      user.old_external_id = old_user['externalId']
      user.first_name = old_user['firstName']
      user.last_name = old_user['lastName']
      user.organisation_id = organisation.id
      user.password = password
      user.save
    elsif old_users.size > 1
      byebug
    else # Otherwise do nothing - this service will hve no associated users in it's org.
    end
  else
    byebug
  end

  service.organisation = organisation

  service.snapshot_action = "import"
  if (row['ecd_opt_out_website'] == 'Hide completely from public website') || (row['ecd_opt_out_website'] == 'Admin access only, never on website')
    service.discarded_at = Time.now
  end

  if row['venue_name'].present? && (Location.where('lower(name) = ?', row['venue_name'].downcase).size > 0) # Assign location if already exists
    service.locations << Location.where('lower(name) = ?', row['venue_name'].downcase).first
  else # Otherwise create a new one
    location = Location.new
    location.name = row['venue_name']
    location.address_1 = [row['venue_address_1'], row['venue_address_2']].join(' ')
    location.city = row['venue_address_4']
    location.state_province = 'Buckinghamshire'
    location.postal_code = row['venue_postcode']
    location.latitude = row['latitude']
    location.longitude = row['longitude']
    location.country = 'GB'
    location.save
    service.locations << location
  end

  unless row['familychannel'] == nil
    lines = row['familychannel'].split("\n")
    lines.each do |line|
      categories = line.split(' > ')
      categories.delete("Family Information")
      parent_cateogry = categories.first
      child_category = categories.last unless categories.size == 1 # is a parent category
      parent_taxonomy = Taxonomy.find_or_create_by(name: parent_cateogry) if parent_cateogry
      child_taxonomy = Taxonomy.find_or_create_by(name: child_category, parent_id: parent_taxonomy.id) if child_category # otherwise tries to create with name nil
      service.taxonomies |= [parent_taxonomy] if parent_taxonomy
      service.taxonomies |= [child_taxonomy] if child_taxonomy
    end
  end

  service.save

  contact = Contact.new
  contact.service_id = service.id
  contact.name = row['contact_name']
  contact.title = row['contact_position']
  contact.save

  phone = Phone.new
  phone.contact_id = contact.id
  phone.number = row['contact_telephone']
  phone.save

end