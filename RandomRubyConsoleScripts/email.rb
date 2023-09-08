emails = Set.new(%w(networks@shift.com jason.barron@cincyredbike.org ameriprise.invoice.processing@ampf.com sfrohman@powerhousedynamics.com thomas.haunert@ge.com svoeung@cpssecurity.com mcaasservice@mtrx.com daniel.clark@captiveaire.com vijay@einsite.io accountpayable@zoomsystems.com kashallan11@yahoo.com info@kistechllc.com supplierinvoice.8130@dnvgl.com demo@monster.com sue.king@ge.com f.schwingenschloegl@hoffman-krippner.com caitlin@bodyport.com paul.liao@dlink.com aseul@plenty.ag us-accounts@viprinet.com tom.darling@viasat.com bpayment@venturiaerospace.com bdeangelo@sbcinc.info bruce@industrialcorrosion.com hesper@plenty.org jpiniak@getample.com nsingh@seeonic shawn@eugeniussolutions.com jzindrick@pos360.com kayla@bdrholdings.com zed@knightscope.com joe.shen@tetratech.com paulerdal@peeds.net pablo@scoot.co jags@otosense.com jared@terrasense.io it-opes@checkvideo.com ptrinkle@quidel.com cogan.clark@fronius.com xzhou@comprimis james.shaker@glacierwater.com steve.nunamaker@kelvininc.com mmmmm@nnn.com nick@theturnkeyteam.com whitneyr@canyonco.org cory.hill@10barrel.com ronengerbreston@gmail.com rkramer@pga.com elyse.stoller@state.or.us manu@dronedeploy.com dunan.mcintyre@meshh.com philipjunker1978@gmail.com kevin@grandcentralbakery.com richardspellman@cauzway.com finance@owlized.com apinquires@oakley.com neng@yelp.com erwin.carrillo@irdinc.com jhohm@agsense.com))

emails = Set.new(%w(twarren@ipsourcellc.com dalejohnston@unitedoil.net invoices@cfgo.com abowser@diversifiedus.com todd.childs@hornblower.com accounts_payable@diversifiedus.com chris.liebig@advantagecontrols.com kelly.reynolds@advantagecontrols.com dawhite@diversifiedus.com timc@litecontruction.com archeryclub4fun@comcast.net neil@voltus.co it-opes@checkvideo.com svoeung@cpssecurity.com sfrohman@powerhousedynamics.com info@kistechllc.com jason.barron@cincyredbike.org ronengerbreston@gmail.com mcaasservice@mtrx.com supplierinvoice.8130@dnvgl.com vijay@einsite.io))


ics = Account.where(account_number: %w(10446541-463859 40372388-181532 47939512-499835 63624600-560882 22207320-867038 41311373-354821 93189816-711389 40679474-239802 87307119-213379 33270376-952355 57200860-363423 51671343-102579 67312626-323415 34686485-609856 22207320-867038 66982860-901197 20705556-877805 11862367-738647 39695146-645954 24384655-264498 79280843-204868 58145427-778366 38225939-115895 71830744-693469 22749552-870285 70767000-898336 50364924-268313 52926936-261274 68285216-179966 88346919-920747 73164534-123051 56303995-734582 74045714-959662 65683602-390386 85429738-755001 50243270-393822 29136958-614701 53503147-945643 37444457-455025 90600852-918921 92198509-446495 85009426-395369 74812348-736288 40670488-489769 18284947-114140 26203372-687451 32598639-910525 54512884-522869 24562438-881225 69798283-861464 85083852-898789 27955963-101619 10324637-824802 88126794-469002 53748252-789585 72135150-417742 83626577-542174 31462314-221232 55684813-200965)).map { |ac| ac.intacct_configuration }

bad_ones = ics.select { |ic| x = Set.new(ic.m2m_billing_emails&.split(/\s*,\s*/)); x.intersect?(emails) }

bad_ones.map { |ic| x = Set.new(ic.m2m_billing_emails&.split(/\s*,\s*/)); [ic.billto, *x.intersection(emails)] }

SVCS_D-Link Systems, paul.liao@dlink.com
SVCS_canyon County Sheriff's Office, whitneyr@canyonco.org
SVCS_Bodyport, caitlin@bodyport.com
SVCS_Vipri Net, us-accounts@viprinet.com
SVCS_10 Barrel, cory.hill@10barrel.com
SVCS_Erik's Festivus, philipjunker1978@gmail.com
SVCS_Erik's Roseville, ronengerbreston@gmail.com
SVCS_SBC Inc, bdeangelo@sbcinc.info
SVCS_Plenty Unlimited, aseul@plenty.ag
SVCS_Cincy Bike Share, Inc., jason.barron@cincyredbike.org
SVCS_TurnKey, nick@theturnkeyteam.com
SVCS_Ameriprise Financial Svc M2M, ameriprise.invoice.processing@ampf.com
SVCS_Terrasense, jared@terrasense.io
SVCS_Owlized, Inc., finance@owlized.com
SVCS_Hoffman + Krippner Inc, f.schwingenschloegl@hoffman-krippner.com
SVCS_GreenPowerMonitor, supplierinvoice.8130@dnvgl.com
SVCS_POS360, jzindrick@pos360.com
SVCS_Drone Deploy, manu@dronedeploy.com
SVCS_Oakley Inc, apinquires@oakley.com
SVCS_Meshh Group, dunan.mcintyre@meshh.com
SVCS_OtoSense, jags@otosense.com
SVCS_Cauzway LLC, richardspellman@cauzway.com
