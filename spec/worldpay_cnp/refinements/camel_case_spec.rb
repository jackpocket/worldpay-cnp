RSpec.describe WorldpayCnp::Refinements::CamelCase do

  using described_class

  it "camel cases a hash" do
    hash = {
      order_id: 1,
      user: {
        first_name: "Alan"
      },
      sample_colors: [
        :blue,
        { color_name: "Blue" }
      ]
    }

    expect(hash.to_camel_case).to eq(
      orderId: 1,
      user: {
        firstName: "Alan"
      },
      sampleColors: [
        :blue,
        { colorName: "Blue" }
      ]
    )
  end

  it "doesn't mutate hash" do
    hash = { order_id: 1 }
    hash.to_camel_case

    expect(hash).to eq(order_id: 1)
  end

end
