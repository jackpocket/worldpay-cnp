RSpec.describe WorldpayCnp::Refinements::DeepSymbolizeKeys do

  using described_class

  it "deep symbolizes hash keys" do
    hash = {
      "a" => [
        { "b" => 1 }
      ],
      "c" => {
        "d" => 2
      }
    }

    expect(hash.deep_symbolize_keys).to eq(
      a: [
        { b: 1 }
      ],
      c: {
        d: 2
      }
    )
  end

  it "doesn't mutate hash" do
    hash = { "a" => 1 }
    hash.deep_symbolize_keys

    expect(hash).to eq("a" => 1)
  end

end
