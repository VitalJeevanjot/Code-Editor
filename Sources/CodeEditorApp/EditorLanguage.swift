import Foundation

enum EditorLanguage: String, CaseIterable, Identifiable {
    case javascript
    case typescript
    case go
    case rust
    case html
    case css

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .javascript:
            return "JavaScript / Node.js"
        case .typescript:
            return "TypeScript"
        case .go:
            return "Go"
        case .rust:
            return "Rust"
        case .html:
            return "HTML"
        case .css:
            return "CSS"
        }
    }

    var starterTemplate: String {
        switch self {
        case .javascript:
            return """
            import http from "http";

            const server = http.createServer((req, res) => {
              res.writeHead(200, { "Content-Type": "application/json" });
              res.end(JSON.stringify({ status: "ok" }));
            });

            server.listen(3000, () => console.log("Listening on 3000"));
            """
        case .typescript:
            return """
            type User = { id: string; name: string };

            const users: User[] = [
              { id: "1", name: "Ada" },
              { id: "2", name: "Linus" }
            ];

            const findUser = (id: string) => users.find((user) => user.id === id);
            """
        case .go:
            return """
            package main

            import (
                "encoding/json"
                "net/http"
            )

            func main() {
                http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
                    _ = json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
                })

                http.ListenAndServe(":3000", nil)
            }
            """
        case .rust:
            return """
            use serde::Serialize;
            use warp::Filter;

            #[derive(Serialize)]
            struct Status {
                status: &'static str,
            }

            #[tokio::main]
            async fn main() {
                let route = warp::path::end().map(|| warp::reply::json(&Status { status: "ok" }));
                warp::serve(route).run(([127, 0, 0, 1], 3030)).await;
            }
            """
        case .html:
            return """
            <!DOCTYPE html>
            <html lang="en">
              <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Starter</title>
                <link rel="stylesheet" href="styles.css" />
              </head>
              <body>
                <main class="container">
                  <h1>Welcome</h1>
                  <p>Edit this HTML and CSS with instant preview.</p>
                </main>
              </body>
            </html>
            """
        case .css:
            return """
            :root {
              color-scheme: light dark;
              font-family: "Inter", system-ui, sans-serif;
            }

            body {
              margin: 0;
              padding: 2rem;
              background: #0f172a;
              color: #e2e8f0;
            }

            .container {
              max-width: 720px;
              margin: 0 auto;
            }
            """
        }
    }

    var keywords: [String] {
        switch self {
        case .javascript:
            return [
                "const", "let", "var", "function", "return", "async", "await", "import", "export",
                "from", "class", "extends", "new", "try", "catch", "throw", "if", "else",
                "switch", "case", "for", "while", "break", "continue"
            ]
        case .typescript:
            return [
                "type", "interface", "implements", "enum", "public", "private", "protected",
                "readonly", "abstract", "as", "const", "let", "function", "return", "async", "await"
            ]
        case .go:
            return [
                "package", "import", "func", "return", "type", "struct", "interface", "go",
                "defer", "if", "else", "switch", "case", "for", "range", "map", "chan"
            ]
        case .rust:
            return [
                "fn", "let", "mut", "struct", "enum", "impl", "trait", "use", "pub",
                "crate", "mod", "match", "if", "else", "loop", "while", "for", "async", "await"
            ]
        case .html:
            return ["div", "section", "header", "main", "footer", "nav", "article", "aside", "button", "form"]
        case .css:
            return ["display", "flex", "grid", "align-items", "justify-content", "gap", "padding", "margin"]
        }
    }

    var completions: [String] {
        switch self {
        case .javascript:
            return [
                "fetch(url).then(res => res.json())",
                "app.get(\"/route\", (req, res) => {\n  res.json({ status: \"ok\" });\n});",
                "console.log(\"debug\")"
            ]
        case .typescript:
            return [
                "interface Name {\n  id: string;\n}",
                "type Result = { ok: boolean };",
                "const data: Record<string, string> = {}"
            ]
        case .go:
            return [
                "http.HandleFunc(\"/path\", func(w http.ResponseWriter, r *http.Request) {\n  w.WriteHeader(http.StatusOK)\n})",
                "type Server struct {\n  Addr string\n}"
            ]
        case .rust:
            return [
                "#[derive(Debug)]\nstruct Item {\n  id: i32,\n}",
                "match value {\n  Some(v) => v,\n  None => return,\n}",
                "let response = reqwest::get(url).await?;"
            ]
        case .html:
            return [
                "<section class=\"section\">\n  <h2>Title</h2>\n</section>",
                "<button class=\"btn\">Click</button>"
            ]
        case .css:
            return [
                "display: flex;\nalign-items: center;\njustify-content: center;",
                "grid-template-columns: repeat(12, 1fr);"
            ]
        }
    }
}
