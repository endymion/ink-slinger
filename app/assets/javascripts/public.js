function init() {
    var editor = grapesjs.init({
      allowScripts: 1,
      autorender: 0,
      noticeOnUnload: 0,
      container: "#gjs",
      height: "700px",
      fromElement: true,
      clearOnRender: 0,

      // add plugins
      plugins: ['gjs-plugin-ckeditor'],
      pluginsOpts: {
        'gjs-plugin-ckeditor': {
          // options goes here
        }
      },


      commands: {
        defaults: [{
            id: "undo",
            run: function (editor, sender) {
              sender.set("active", false);
              editor.UndoManager.undo(1);
            }
          },
          {
            id: "redo",
            run: function (editor, sender) {
              sender.set("active", false);
              editor.UndoManager.redo(1);
            }
          },
          {
            id: "clean-all",
            run: function (editor, sender) {
              sender.set("active", false);
              if (confirm("Are you sure to clean the canvas?")) {
                var comps = editor.DomComponents.clear();
              }
            }
          },
          {
            id: "save",
            run: function (editor, senderBtn) {
              sender.set("active", false);
              saveHtmlToList(editor);
            },
            stop: function (editor, senderBtn) {}
          }
        ]
      },

      blockManager: {
        blocks: [
          {
            id: 'section', // id is mandatory
            label: '<b>Section</b>', // You can use HTML/SVG inside labels
            attributes: { class:'gjs-block-section' },
            content: `<section>
              <h1>This is a simple title</h1>
              <div>This is just a Lorem text: Lorem ipsum dolor sit amet</div>
            </section>`,
          },
          {
            id: 'text',
            label: 'Text',
            content: '<div data-gjs-type="text">Insert your text here</div>',
          },
          {
            id: 'image',
            label: 'Image',
            // Select the component once it's dropped
            select: true,
            // You can pass components as a JSON instead of a simple HTML string,
            // in this case we also use a defined component type `image`
            content: { type: 'image' },
            // This triggers `active` event on dropped components and the `image`
            // reacts by opening the AssetManager
            activate: true,
          }
        ]
      },
  });

  var pnm = editor.Panels;
    pnm.addButton("options", [{
      id: "undo",
      className: "fa fa-undo icon-undo",
      command: function command(editor, sender) {
        sender.set("active", 0);
        editor.UndoManager.undo(1);
      },
      attributes: {
        title: "Undo (CTRL/CMD + Z)"
      }
    }, {
      id: "redo",
      className: "fa fa-repeat icon-redo",
      command: function command(editor, sender) {
        sender.set("active", 0);
        editor.UndoManager.redo(1);
      },
      attributes: {
        title: "Redo (CTRL/CMD + Y)"
      }
    }]);

   editor.render();
 }

window.onload = function() {
  init();
};
