class ConvertCertificateReceivedToBoolean < ActiveRecord::Migration
  def self.up
    change_table :enrollments do |t|
      t.change :certificate_received, "boolean USING CASE WHEN (certificate_received = null) THEN false ELSE true END;", :default => false
    end
  end

  def self.down
    change_table :enrollments do |t|
      t.change :certificate_received, :date
    end
  end
end
