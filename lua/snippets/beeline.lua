local ls = require("luasnip")
local snip = ls.snippet
local node = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

ls.add_snippets(nil, {
    all = {
        snip({
            trig = "dataclass",
            -- namr = "Collapse pydantic.dataclass",
            dscr = "Collapse pydantic.dataclass",
        },
        {
            t({"@dataclass", ""}),
            t("class "), i(1, "ClassName"), i(2, "(ParentClasses)"),t({":", ""}),
        }),
    },
})

