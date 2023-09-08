d_id = 129396
dev = Device.find(d_id)
IpAssignment.where(device_id: d_id).empty?
Assignment.where(device_id: d_id).empty?
Sublet.where(device_id: d_id).empty?
ViewConfiguration.where(device_id: d_id).empty?
OperationTicket.where(device_id: d_id).empty?
AvmsDevice.where(device_id: d_id).empty?
CalampDevice.where(device_id: d_id).empty?
WarmCalampMessage.where(device_id: d_id).empty?
GeocodeHistory.where(device_id: d_id).empty?
JournalEntry.where(device_id: d_id).empty?
RazorFirmwareJob.where(device_id: d_id).empty?
DeviceTrigger.where(target_id: d_id).empty?
DeviceNeedsCalampCheck.where(device_id: d_id).empty?
AttCdr.where(device_id: d_id).empty?
AttCdr.warm.where(device_id: d_id).empty?
JasperCdr.where(device_id: d_id).empty?
JasperLatestCdr.where(device_id: d_id).empty?
DeviceReport.where(device_id: d_id).empty?
WarmDeviceReport.where(device_id: d_id).empty?
DailyDataUsage.where(device_id: d_id).empty?
WarmDailyDataUsage.where(device_id: d_id).empty?
MonthlyDataUsage.where(device_id: d_id).empty?
WarmMonthlyDataUsage.where(device_id: d_id).empty?
RadacctCdr.where(device_id: d_id).empty?

