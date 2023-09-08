# Revenue/Line numbers for roevic

class Reporter
  attr_accessor :handler, :report

  def initialize
    @handler = IntacctApiHandler.new
    @yr2018 = Date.parse '2018-01-01'
    @yr2019 = Date.parse '2019-01-01'
    @yr2020 = Date.parse '2020-01-01'
    @yr2021 = Date.parse '2021-01-01'
    @report = [%w(AccountName RatePlanName Rep(s) 2018lines 2019lines 2020lines 2021lines 2018rev 2019rev 2020rev 2021rev)]
  end

  def account_chunk(act) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    details = []
    details << [act.account_name, '', ac_reps(act),
                ac_lines_per_year(act, @yr2018),
                ac_lines_per_year(act, @yr2019),
                ac_lines_per_year(act, @yr2020),
                ac_lines_per_year(act, @yr2021, div: Date.today.month - 1),
                ac_revenue_per_year(act, @yr2018),
                ac_revenue_per_year(act, @yr2019),
                ac_revenue_per_year(act, @yr2020),
                ac_revenue_per_year(act, @yr2021)]
    act.rate_plans.each do |rp|
      details << ['',
                  rp.name,
                  rp_reps(rp),
                  rp_lines_per_year(rp, @yr2018),
                  rp_lines_per_year(rp, @yr2019),
                  rp_lines_per_year(rp, @yr2020),
                  rp_lines_per_year(rp, @yr2021, div: Date.today.month - 1),
                  '',
                  '',
                  '',
                  '']
    end
    details << []
    details
  end

  def assemble_report(start_at: 0)
    (Account.where.not(account_state: 'not-billed-misc').where('id >= ?', start_at) - Account.special_accounts).each do |ac|
      @report += account_chunk(ac)
    end
  end

  def load_report(path_to_file)
    @report = YAML.load_file path_to_file
  end

  # NEED TO FIGURE OUT WHY RAZOR IS 50k+ lines when they are prorating/TRMing away every month...
  def rp_lines_per_year(id, date, div: 12)
    (BillingHistory.where(billing_period: date.beginning_of_year..date.end_of_year).where(rate_plan_id: id).sum(:percentage) / div).round(1)
  end

  def ac_lines_per_year(act, date, div: 12)
    (BillingHistory.where(billing_period: date.beginning_of_year..date.end_of_year).where(account_id: act.id).sum(:percentage) / div).round(1)
  end

  def rp_reps(rate_plan)
    cc = rate_plan.commission_configuration
    [cc.rep1, cc.rep2].compact.uniq.join(' + ')
  end

  def ac_reps(act)
    act.rate_plans.map { |rp| rp_reps(rp) }.compact.uniq.join(' + ')
  end

  def ac_revenue_per_year(act, date)
    ic = act.intacct_configuration
    invoices = ic.fetch_invoice_data(date.beginning_of_year..date.end_of_year, @handler)
    invoices.pluck(:totalentered).map { |x| x.delete(',').to_f }.sum
  end
end
