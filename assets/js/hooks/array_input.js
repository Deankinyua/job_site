const ArrayInputHooks = {};

ArrayInputHooks.ArrayInput = {
  mounted() {
    const inputEl = this.el;
    const inputElId = inputEl.id;
    const arrayInputName = inputEl.name.slice(0, -"-add-input".length);

    const addButtonId = inputElId + "_add_button";
    const addButton = document.getElementById(addButtonId);

    const orderedListId = inputElId + "_list_container";
    const orderedList = document.getElementById(orderedListId);

    addButton.addEventListener("click", () => {
      const currentInputValue = inputEl.value;

      currentInputValue === "" ? null : addItem(currentInputValue);

      inputEl.value = "";
    });

    orderedList.addEventListener("remove-item", (e) => {
      const listItemId = inputElId + "_list_item_" + e.target.dataset.number;

      const listItem = document.getElementById(listItemId);

      listItem.remove();
    });

    const addItem = (newValue) => {
      const orderedList = document.getElementById(orderedListId);
      const lastListElement = orderedList.lastElementChild;

      const newElementIndex = lastListElement
        ? Number(lastListElement.dataset.number) + 1
        : "1";

      addListItem(
        orderedList,
        newElementIndex,
        inputElId,
        arrayInputName,
        newValue,
      );
    };

    const addListItem = (orderedList, index, id, name, value) => {
      const li = document.createElement("li");
      li.id = `${id}_list_item_${index}`;
      li.dataset.number = String(index);
      li.className = "flex justify-between";

      const span = document.createElement("span");
      span.textContent = value;

      const input = document.createElement("input");
      input.type = "hidden";
      input.name = name;
      input.id = `${id}-${index}`;
      input.value = value;

      const button = document.createElement("button");
      button.type = "button";
      button.id = `${id}_list_item_${index}_remove_btn`;
      button.dataset.number = String(index);
      button.textContent = "Remove";

      button.addEventListener("click", () => {
        li.dispatchEvent(new CustomEvent("remove-item", { bubbles: true }));
      });

      li.append(span, input, button);
      orderedList.appendChild(li);

      return li;
    };
  },
};

export default ArrayInputHooks;
