class RequisitionLineItem < ActiveRecord::Base
    belongs_to :requisition
    
    validates :amount, presence: {in: true, message: "can't be blank unless the whole row is blank"}
    attr_accessible :comments, :s_number, :charge_code, :override, :amount, :received, :reconciled

 
    def mark_received
        self.received = true
    end

    def mark_not_received
        self.received = false
    end

    def toggle_received
        self.received = !self.received
    end

    def received?
        self.received ? true : false
    end

    def mark_reconciled
        self.reconciled = true
    end

    def mark_not_reconciled
        self.reconciled = false
    end

    def toggle_reconciled
        self.reconciled = !self.reconciled
    end

    def reconciled?
        self.reconciled ? true : false
    end
end
