package madolib;

import madolib.event.Signal;

enum AchievementError {
    NotExistingId(id: String);
}

@:structInit
typedef AchievementData = {
    name: String,
    achieved: Bool,
    description: String,
}

@:generic
class Achievement {
    var data: Map<String, AchievementData> = [];

    public final onAchieved = new Signal<String>();

    public function new(data: Map<String, AchievementData>) {
        this.data = data;
    }

    public inline function unlock(id: String) {
        final achievement = data.get(id);
        if(achievement != null) {
            achievement.achieved = true;
            onAchieved(id);
        }
    }

    public inline function getAchievement(id: String): Result<AchievementError, AchievementData> {
        final achievement = data.get(id);
        return if(achievement == null) {
            Err(NotExistingId(id));
        } else {
            Ok({
                name: achievement.name,
                achieved: achievement.achieved,
                description: achievement.description,
            });
        }
    }
}
