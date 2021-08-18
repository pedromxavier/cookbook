import json
from pylatex import Document, Section, Subsection, Command
from pylatex.base_classes import Environment
from pylatex.utils import italic, NoEscape


class Week(Environment):
    escape = False
    content_separator = "\n"
    environment_name = 'week'

class WeekDoc(Document):

    def __init__(self, data):
        super().__init__(documentclass='week', document_options=['pastel', 'br'])

        self.preamble.append(Command('title', 'Semana do Pedro 2021.1'))
        self.preamble.append(Command('date', NoEscape(r'\today')))

        self.load_json(data)

    def load_json(self, data):
        with self.create(Week()):
            for item in data:
                self.append(Command('xtask', [NoEscape(item['name']), item['day'], item['days'], item['hour'], item['hours']], [item['color']]))

with open('week.json', 'r', encoding='utf-8') as fd:
    doc = WeekDoc(json.load(fd))
    doc.generate_pdf('pedro-week', clean_tex=False)