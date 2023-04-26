defmodule Seed.Entities.Repository.Updater do
  alias Seed.Database.Repo
  alias Seed.Entities.Schema.Entity
  import Seraph.Query

  def update_color(root_id, entity_id, color) do
    Repo.query(
      """
      MATCH (root:Root {uuid: $app_id})-[is_data:IS_ENTITY]-(n {uuid: $entity_id})
      SET n.color = $color
      RETURN n
      """,
      %{
        app_id: root_id,
        entity_id: entity_id,
        color: color
      }
    )
  end
end
