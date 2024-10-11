import { action } from "@ember/object";
import { service } from "@ember/service";
import DiscourseRoute from "discourse/routes/discourse";

export default class AutomationIndex extends DiscourseRoute {
  @service router;

  controllerName = "admin-plugins-discourse-automation-index";

  afterModel(model) {
    if (!model.length) {
      this.router.transitionTo("adminPlugins.discourse-automation.new");
    }
  }

  model() {
    return this.store.findAll("discourse-automation-automation");
  }

  @action
  triggerRefresh() {
    this.refresh();
  }
}
