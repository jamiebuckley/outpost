class Snapshot < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :service

  paginates_per 20

  def restore
    # 1. Find the live version of the current object
    live_object = Service.find(self.service_id)

    # 2. Restore need associations, recreating any deleted options
    # live_object.send_needs.destroy_all
    # self.object["send_needs"].each do |n|
    #   live_object.send_needs << SendNeed.find_or_create_by(name: n["name"])
    # end
    live_object.taxonomies.destroy_all
    self.object["taxonomies"].each do |n|
      live_object.taxonomies << Taxonomy.find_or_create_by(name: n["name"], parent_id: n["parent_id"])
    end
    
    live_object.locations.destroy_all
    self.object["locations"].each do |n|
      live_object.locations << Location.find_or_create_by(name: n["name"], address_1: n["address_1"], city: n["city"], postal_code: n["postal_code"])
    end

    live_object.contact.destroy

    live_object.contact = Contact.new
    live_object.contact.name = self.object["contact"]["name"]
    live_object.contact.title = self.object["contact"]["title"]
    
    live_object.contact.phone = Phone.new
    live_object.contact.phone.number =  self.object["phone"]["number"]

    # 3. Restore plain attributes
    live_object.name = self.object["name"]
    live_object.description = self.object["description"]
    # ...

    # 4. Finally, save the object
    live_object.snapshot_action = "restore"
    live_object.save
  end
end