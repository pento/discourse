import Component from "@glimmer/component";
import DButton from "discourse/components/d-button";
import concatClass from "discourse/helpers/concat-class";
import i18n from "discourse-common/helpers/i18n";

export default class PostMenuReplyButton extends Component {
  static shouldRender(post, context) {
    return context.canCreatePost;
  }

  <template>
    {{#if @shouldRender}}
      <DButton
        class={{concatClass "reply" (if @showLabel "create fade-out")}}
        ...attributes
        @icon="reply"
        @title="post.controls.reply"
        @label={{if @showLabel "topic.reply.title"}}
        @translatedAriaLabel={{i18n
          "post.sr_reply_to"
          post_number=@post.post_number
          username=@post.username
        }}
        @action={{@action}}
      />
    {{/if}}
  </template>
}
