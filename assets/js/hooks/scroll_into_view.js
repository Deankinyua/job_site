let ScrollIntoViewHooks = {};

ScrollIntoViewHooks.ScrollIntoView = {
  mounted() {
    this.el.scrollIntoView({
      behavior: "smooth",
      block: "start",
    });
  },
};

export default ScrollIntoViewHooks;
