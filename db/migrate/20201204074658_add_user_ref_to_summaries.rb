class AddUserRefToSummaries < ActiveRecord::Migration[5.2]
  def change
    add_reference :summaries, :user, foreign_key: true
  end
end
