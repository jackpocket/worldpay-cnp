RSpec.describe WorldpayCnp::Refinements::SnakeCase do

  using described_class

  it "snake cases a hash" do
    hash = {
      orderId: 1,
      user: {
        firstName: "Alan"
      },
      sampleColors: [
        :blue,
        { colorName: "Blue" }
      ]
    }

    expect(hash.to_snake_case).to eq(
      order_id: 1,
      user: {
        first_name: "Alan"
      },
      sample_colors: [
        :blue,
        { color_name: "Blue" }
      ]
    )
  end

  it "doesn't mutate hash" do
    hash = { orderId: 1 }
    hash.to_snake_case

    expect(hash).to eq(orderId: 1)
  end

end
