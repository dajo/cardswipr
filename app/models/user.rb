class User < ActiveRecord::Base
  validates :netid, presence: true, uniqueness: true
  has_and_belongs_to_many :event

  after_create :get_ldap_attributes

  def get_ldap_attributes
    attributes = YaleLDAP.lookup(netid: netid)
      .slice(:first_name, :last_name, :netid)
    self.update_attributes(attributes)
  end

  def full_name
    full_name = first_name + " " + last_name
  end

  def full_name_with_netid
    full_name + " " + netid
  end
end
