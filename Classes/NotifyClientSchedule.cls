/**
 * Created by semis on 12.10.2022.
 */

global class NotifyClientSchedule implements Schedulable {
    global void execute(SchedulableContext ctx) {
        NotifyClientBatch b = new NotifyClientBatch();
        database.executeBatch(b);
    }
}