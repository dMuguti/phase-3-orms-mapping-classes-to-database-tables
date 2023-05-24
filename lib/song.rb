class Song
  attr_accessor :id, :name, :album

  def initialize(id: nil, name:, album:)
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      update
    else
      insert
    end
    self
  end

  def insert
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.album)
    @id = DB[:conn].last_insert_row_id
  end
def update
    sql = <<-SQL
      UPDATE songs
      SET name = ?, album = ?
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.album, self.id)
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end
end