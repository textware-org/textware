-- Insert a default user (username: admin, password: admin)
INSERT OR IGNORE INTO users (username, password) VALUES ('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918');

-- Insert initial content
INSERT INTO content (markdown) VALUES ('# Welcome to Markdown Editor

This is your initial content. You can edit this in the editor.');

-- Insert initial metadata
INSERT INTO metadata (title, description) VALUES ('My Markdown Site', 'A simple markdown editor and publisher');