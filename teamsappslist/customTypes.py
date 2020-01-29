class App(object):
    id = ''
    title = ''

    def __init__(self, id: str, title: str):
        super().__init__()
        self.id = id
        self.title = title
