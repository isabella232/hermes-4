class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sites, inverse_of: :user, dependent: :destroy
  has_many :tutorials, through: :sites

  def tips
    Tip.where(id: tip_ids)
  end

  def tip_ids
    Tip.where(tippable: sites).pluck(:id) | \
      Tip.where(tippable: tutorials).pluck(:id)
  end

  def admin?
    false #To be implemented
  end
end
